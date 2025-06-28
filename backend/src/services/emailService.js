// src/services/emailService.js

const nodemailer = require('nodemailer');

// Konfigurasi transporter tidak berubah
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

// --- TEMPLATE HTML BARU YANG BISA DIGUNAKAN KEMBALI ---
const createHtmlTemplate = (title, message, otp) => {
  const primaryColor = '#008080'; // Warna Teal, bisa Anda ganti sesuai tema
  const backgroundColor = '#f4f4f4';
  const textColor = '#333333';

  return `
    <body style="font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: ${backgroundColor};">
      <table align="center" border="0" cellpadding="0" cellspacing="0" width="600" style="border-collapse: collapse; margin: 20px auto; border: 1px solid #cccccc;">
        
        <tr>
          <td align="center" bgcolor="${primaryColor}" style="padding: 20px 0;">
            <h1 style="color: #ffffff; margin: 0; font-size: 24px;">Klinik App</h1>
          </td>
        </tr>

        <tr>
          <td bgcolor="#ffffff" style="padding: 40px 30px;">
            <h2 style="color: ${textColor}; text-align: center;">${title}</h2>
            <p style="color: ${textColor}; font-size: 16px; line-height: 1.5; text-align: center;">
              ${message}
            </p>
            
            <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top: 30px; margin-bottom: 30px;">
              <tr>
                <td align="center">
                  <div style="background-color: #f0f0f0; border-radius: 8px; padding: 15px 20px; display: inline-block;">
                    <p style="color: ${primaryColor}; font-size: 32px; font-weight: bold; letter-spacing: 8px; margin: 0;">
                      ${otp}
                    </p>
                  </div>
                </td>
              </tr>
            </table>

            <p style="color: #777777; font-size: 14px; text-align: center;">
              Kode ini hanya berlaku selama 10 menit. Jika Anda tidak merasa melakukan permintaan ini, abaikan saja email ini.
            </p>
          </td>
        </tr>

        <tr>
          <td bgcolor="#eeeeee" style="padding: 20px 30px;">
            <p style="color: #777777; font-size: 12px; text-align: center; margin: 0;">
              &copy; ${new Date().getFullYear()} Klinik App(Kelompok 1 Mobile Programming 17.5A.07). Semua Hak Cipta Dilindungi.
            </p>
          </td>
        </tr>
      </table>
    </body>
  `;
};


// --- FUNGSI PENGIRIMAN EMAIL SEKARANG MENGGUNAKAN TEMPLATE BARU ---

// Fungsi untuk mengirim email OTP Registrasi
exports.sendOtpEmail = async (to, otp) => {
  const title = 'Verifikasi Email Anda';
  const message = 'Gunakan kode di bawah ini untuk menyelesaikan pendaftaran Anda:';
  
  const htmlContent = createHtmlTemplate(title, message, otp);

  const mailOptions = {
    from: `"Klinik App" <${process.env.EMAIL_USER}>`,
    to: to,
    subject: 'Kode Verifikasi Registrasi Anda',
    html: htmlContent, // Menggunakan template HTML baru
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log(`Email OTP Registrasi terkirim ke: ${to}`);
  } catch (error) {
    console.error(`Gagal mengirim email registrasi ke ${to}:`, error);
    throw new Error('Gagal mengirim email verifikasi');
  }
};

// Fungsi untuk mengirim email OTP Reset Password
exports.sendPasswordResetOtp = async (to, otp) => {
  const title = 'Reset Password Anda';
  const message = 'Seseorang (semoga Anda) telah meminta untuk mereset password. Gunakan kode di bawah ini:';
  
  const htmlContent = createHtmlTemplate(title, message, otp);
  
  const mailOptions = {
    from: `"Klinik App" <${process.env.EMAIL_USER}>`,
    to: to,
    subject: 'Permintaan Reset Password',
    html: htmlContent,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log(`Email OTP Reset Password terkirim ke: ${to}`);
  } catch (error) {
    console.error(`Gagal mengirim email reset password ke ${to}:`, error);
    throw new Error('Gagal mengirim email reset password');
  }
};