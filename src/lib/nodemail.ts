import nodemailer from 'nodemailer';

export const sendEmailVerify = async (subject: string, to: string, html: string) => {

    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth:{
            user: 'HERE YOUR GMAIL ADRESS',
            pass: 'HERE YOUR GMAIL PASSWORD'
        }
    });


    const mailOptions = {
        from: 'HERE YOUR GMAIL ADDRESS',
        to: to,
        subject: subject,
        html: html,
    };

    await transporter.sendMail( mailOptions );

} 