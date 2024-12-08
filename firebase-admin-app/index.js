const admin = require("firebase-admin");
const serviceAccount = require("/dart/github/project kampus/demand/serviceAccountKey.json");

// Inisialisasi Firebase Admin SDK
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://demand-ff258-default-rtdb.asia-southeast1.firebasedatabase.app"
});

// Tes koneksi ke Firestore
const db = admin.firestore();

async function testConnection() {
    try {
        const snapshot = await db.collection("test-collection").get();
        snapshot.forEach((doc) => {
            console.log(doc.id, "=>", doc.data());
        });
        console.log("Connection successful!");
    } catch (error) {
        console.error("Error connecting to Firestore:", error);
    }
}

testConnection();

async function getAllLicenses() {
    try {
        const licenses = [];
        const snapshot = await db.collectionGroup("licenses").get();
        snapshot.forEach((doc) => {
            licenses.push({ id: doc.id, ...doc.data() });
        });
        console.log("All Licenses:", licenses);
    } catch (error) {
        console.error("Error fetching licenses:", error);
    }
}

getAllLicenses();

async function addAdminClaim(uid) {
    try {
        await admin.auth().setCustomUserClaims(uid, { admin: true });
        console.log("Admin claim successfully added!");
    } catch (error) {
        console.error("Error adding admin claim:", error);
    }
}

addAdminClaim("Xvih3PbZm8Y8r8rn0jJ9Fbmh9XG3");

async function verifyAdmin(uid) {
    try {
        const user = await admin.auth().getUser(uid);
        console.log("Custom Claims:", user.customClaims);
    } catch (error) {
        console.error("Error fetching custom claims:", error);
    }
}

verifyAdmin("Xvih3PbZm8Y8r8rn0jJ9Fbmh9XG3");