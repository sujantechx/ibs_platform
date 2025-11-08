const { initializeTestEnvironment, assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');
const fs = require('fs');

async function main() {
  const projectId = 'ibs-platform-rules-test';
  const rules = fs.readFileSync('firestore.rules', 'utf8');

  // If running with `firebase emulators:exec`, the test harness will be able to auto-discover the emulator.
  // If running the emulator separately, set FIRESTORE_EMULATOR_HOST=127.0.0.1:8080 (or your host:port) before running this script.
  let testEnv;
  try {
    if (process.env.FIRESTORE_EMULATOR_HOST) {
      const hostPort = process.env.FIRESTORE_EMULATOR_HOST.split(':');
      const host = hostPort[0];
      const port = Number(hostPort[1] || 8080);
      console.log(`Initializing test environment using FIRESTORE_EMULATOR_HOST=${process.env.FIRESTORE_EMULATOR_HOST}`);
      testEnv = await initializeTestEnvironment({
        projectId,
        firestore: { host, port, rules }
      });
    } else {
      // Try to initialize without explicit host/port — this works when running under `firebase emulators:exec`.
      console.log('Initializing test environment without explicit host/port.');
      console.log('If this fails, please run the test using `firebase emulators:exec "node tests/firestore_rules_test.js"` or set FIRESTORE_EMULATOR_HOST environment variable to your running emulator host:port.');
      testEnv = await initializeTestEnvironment({
        projectId,
        firestore: { rules }
      });
    }
  } catch (e) {
    console.error('\nFailed to initialize test environment.');
    console.error('Reason:', e && e.message ? e.message : e);
    console.error('\nTo run these tests locally:');
    console.error('1) Install Firebase CLI: npm install -g firebase-tools');
    console.error('2) Start the Firestore emulator in a separate terminal: firebase emulators:start --only firestore --project YOUR_PROJECT_ID');
    console.error('   or run the test via the emulator wrapper: firebase emulators:exec "node tests/firestore_rules_test.js" --project YOUR_PROJECT_ID');
    console.error('3) If starting the emulator separately, set FIRESTORE_EMULATOR_HOST=127.0.0.1:8080 and run: node tests/firestore_rules_test.js');
    process.exitCode = 1;
    return;
  }

  try {
    // Seed data as admin (security rules disabled in this block)
    await testEnv.withSecurityRulesDisabled(async (context) => {
      const adminDb = context.firestore();
      // Create a vaishnav_puran doc to read publicly
      await adminDb.doc('vaishnav_puran/p1').set({ title: 'Puran 1', description: 'Seed Puran', order: 1 });
      // Create user docs for admin and regular user
      await adminDb.doc('users/adminUid').set({ role: 'admin', status: 'approved' });
      await adminDb.doc('users/userUid').set({ role: 'student', status: 'approved' });
    });

    console.log('Running tests...');

    // Admin authenticated context
    const adminAuth = { uid: 'adminUid', email: 'admin@example.com' };
    const adminCtx = testEnv.authenticatedContext(adminAuth.uid, { email: adminAuth.email });
    const adminDb = adminCtx.firestore();

    // Regular authenticated user
    const userAuth = { uid: 'userUid', email: 'user@example.com' };
    const userCtx = testEnv.authenticatedContext(userAuth.uid, { email: userAuth.email });
    const userDb = userCtx.firestore();

    // Unauthenticated client
    const unauthCtx = testEnv.unauthenticatedContext();
    const unauthDb = unauthCtx.firestore();

    // 1) Public read test: unauthenticated can read existing puran
    console.log('Test: unauthenticated read vaishnav_puran/p1 should succeed');
    await assertSucceeds(unauthDb.doc('vaishnav_puran/p1').get());

    // 2) Admin CRUD should succeed
    console.log('Test: admin create vaishnav_puran/p2 should succeed');
    await assertSucceeds(adminDb.doc('vaishnav_puran/p2').set({ title: 'Puran 2' }));

    console.log('Test: admin update vaishnav_puran/p2 should succeed');
    await assertSucceeds(adminDb.doc('vaishnav_puran/p2').update({ title: 'Puran 2 updated' }));

    console.log('Test: admin delete vaishnav_puran/p2 should succeed');
    await assertSucceeds(adminDb.doc('vaishnav_puran/p2').delete());

    // 3) Regular user write should fail
    console.log('Test: regular user create vaishnav_puran/p3 should fail');
    await assertFails(userDb.doc('vaishnav_puran/p3').set({ title: 'Puran 3' }));

    // 4) Unauthenticated write should fail
    console.log('Test: unauthenticated create vaishnav_puran/p4 should fail');
    await assertFails(unauthDb.doc('vaishnav_puran/p4').set({ title: 'Puran 4' }));

    // 5) Admin can create subject under puran
    console.log('Test: admin create subject under puran should succeed');
    await assertSucceeds(adminDb.doc('vaishnav_puran/p1/subjects/s1').set({ title: 'Subject 1' }));

    // 6) Non-admin cannot create subject
    console.log('Test: user create subject under puran should fail');
    await assertFails(userDb.doc('vaishnav_puran/p1/subjects/s2').set({ title: 'Subject 2' }));

    // 7) Admin can create chapter under subject
    console.log('Test: admin create chapter under subject should succeed');
    await assertSucceeds(adminDb.doc('vaishnav_puran/p1/subjects/s1/chapters/c1').set({ title: 'Chapter 1', content: 'Hello' }));

    // 8) Non-admin cannot create chapter
    console.log('Test: user create chapter under subject should fail');
    await assertFails(userDb.doc('vaishnav_puran/p1/subjects/s1/chapters/c2').set({ title: 'Chapter 2' }));

    console.log('\nAll assertions executed. If no assertion error thrown, rules behave as expected.');

  } catch (err) {
    console.error('Test failed with error:', err);
    process.exitCode = 1;
  } finally {
    await testEnv.clearFirestore();
    await testEnv.cleanup();
  }
}

main().then(() => console.log('Test run completed')).catch(e => { console.error(e); process.exit(1); });
