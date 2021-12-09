import nodemailer from 'nodemailer';

export const sendEmailVerify = async (subject: string, to: string, html: string) => {

    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth:{
            user: 'Here your Gmail Address',
            pass: 'Here your Password'
        },
        tls: {
            rejectUnauthorized: false
        }
    });


    const mailOptions = {
        from: 'Here your Gmail Address',
        to: to,
        subject: subject,
        html: html,
    };

    await transporter.sendMail( mailOptions );

} 