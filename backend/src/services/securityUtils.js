const crypto = require('crypto');

class SecurityUtil {
  // 🔐 Hash password dengan SHA-512 + salt + pepper
  static hashR(password) {
    const pepper = SecurityUtil.getPepper();
    const salt = SecurityUtil.generateSalt();

    const hashpass = crypto.createHash('sha512').update(password).digest('hex');
    const hashedPassword = salt + hashpass + pepper;

    return {
      hash: hashedPassword,
      salt: salt // kembalikan juga salt supaya bisa disimpan di database
    };
  }
  static getSalt(userId){
    const db = require('../models/db');
    return db.query('SELECT salt FROM password WHERE id = ?', [userId])
      .then(([rows]) => {
        if (rows.length > 0) {
          return rows[0].salt;
        } else {
          throw new Error('User not found');
        }
      })
      .catch(err => {
        console.error(err);
        throw err; // lempar error untuk ditangani di tempat lain
      });
  }
  // 🧂 Generate salt acak
  static generateSalt(length = null) {
    if (length === null) {
      length = crypto.randomInt(16, 65); // Panjang antara 16-64
    }

    const characters = '!#$%&\\()*+,-./0123456789<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ^_`abcdefghijklmnopqrstuvwxyz{|}~';
    const charactersLength = characters.length;
    let salt = '';

    for (let i = 0; i < length; i++) {
      const randomIndex = crypto.randomInt(0, charactersLength);
      salt += characters[randomIndex];
    }

    return salt;
  }
  
  // 🌶️ Pepper statik, di-hash juga pakai SHA-512
  static getPepper() {
    const rawPepper = 'bB209bN1656sFq'; // Idealnya simpan di .env
    const pepperHashed = crypto.createHash('sha512').update(rawPepper).digest('hex');
    return pepperHashed;
  }

  // ✅ Verifikasi password input dengan hash + salt yang disimpan
  static async verifyPassword(username, inputPassword) {
  try {
    const [result] = await db.query('SELECT pw FROM user WHERE username = ?', [username]);

    if (!result) {
      return false; // Username tidak ditemukan
    }

    const passwordUser = result.pw;
    
    // Kalau tidak ada hashing:
    return inputPassword === passwordUser;
    
    // Kalau ada hashing (misalnya pakai bcrypt):
    // return await bcrypt.compare(inputPassword, passwordUser);

  } catch (error) {
    console.error('Error verifying password:', error);
    return false;
  }
}

 static async hashLogin(userId, password) {
  // Jika salt tidak dikirim langsung, ambil dari DB berdasarkan userId
  const salt = await SecurityUtil.getSalt(userId); // ✅ tunggu hasil dari DB
  const pepper = SecurityUtil.getPepper();
  const hashInput = crypto.createHash('sha512').update(password).digest('hex');
  const passwordHash = salt + hashInput + pepper;

  
}

}

module.exports = SecurityUtil;
