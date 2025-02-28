require('dotenv').config();
const express=require('express');
const router=express.Router();
const jwt=require('jsonwebtoken'); // tạo và xác thực jwt
const nodemailer=require('nodemailer'); // dùng để gửi email
const User=require('../../models/user');
const bcrypt=require('bcryptjs'); // mã hoá mật khẩu và kiểm tra mật khẩu
const authenticateToken=require('../api/authMiddleware');

router.post('/register',async(req,res)=>{
    const {email, password, fullName, address, phoneNumber, birth, role}=req.body;
    try{
        let user=await User.findOne({email});
        if(user){
            return res.status(400).json({
                message: 'User already exists',
            });
        }
        const salt=await bcrypt.genSalt(10);
        const hashedPassword=await bcrypt.hash(password,salt); //mã hoá mật khẩu 

        user=new User({
            email,
            password: hashedPassword,
            fullName,
            address,
            phoneNumber,
            birth,
            role,
        });
        await user.save();
       
        res.json({
            status: 200,
            message: 'register success',
            data: user,
        });


    }catch(error){
        console.log(error);
    }
});
router.post('/forgot_password',async(req,res)=>{
    const {email}=req.body;
    if(!email){
        return res.status(400).json({message:'Email is require'})
    }
    try{
        const user=await User.findOne({email});
        if(!user){
            return res.status(400).json({message: 'User not found'});
        }
        const otp=Math.floor(100000+Math.random()*900000).toString(); //floor là làm tròn xuống random trả về giá trị từ 0->1 
        user.otp=otp;
        user.otpExpires=Date.now()+180000; // 3 phút sẽ hết hạn
        await user.save();

        //gửi về mail
        const transporter=nodemailer.createTransport({
            service: 'gmail',
            auth:{
                user: process.env.EMAIL,
                pass: process.env.EMAIL_PASSWORD,
            }
        }); //tạo một transporter với dịch vụ từ gmail và các biến môi trường
        const mailOptions={
            from: process.env.EMAIL,
            to: user.email,
            subject: 'Your OTP for password reset',
            text: `Your OTP is ${otp}. It is valid for 3 minutes`
        };// đây là nội dung tin nhắn 
        transporter.sendMail(mailOptions,(error,infor)=>{
            if(error){
                return console.log(error);
            }
            console.log('Email sent: '+infor.response);
        }); //gửi otp về 

        res.json({message: 'OTP sent to email'});

    }catch(error){
        console.log(error);
    }
});
router.post('/verify_otp',async (req,res)=>{
    const {email,otp}=req.body;
   
    if(!email||!otp){
        return res.status(400).json({message:'Email and OTP are required'});
    }
    try{
        const user=await User.findOne({email});
        if(!user){
            return res.status(400).json({message: 'User not found'});
        }
        if(user.otp!=otp){
            return res.status(400).json({ message: 'Invalid OTP' });
        }
        if(Date.now()>user.otpExpires){
            return res.status(400).json({ message: 'OTP has expired' });
        }
        user.otp=null;
        user.otpExpires=null;
        await user.save();
        res.status(200).json({ message: 'OTP verified successfully' });
    }catch(error){  
        console.log(error);
    }
});
router.post('/reset_pass_word',async(req,res)=>{
    const {email,password}=req.body;
    if(!email||!password){
        return res.status(400).json({message:'Email and Pass are required'});
    }
    try{
        const user=await User.findOne({email});
        const salt=await bcrypt.genSalt(10);
        const hashedPassword= await bcrypt.hash(user.password,salt);
        user.password=hashedPassword;
        await user.save();
        res.status(200).json({message: 'Reset pass successfully'});
    }catch(error){
        console.log(error);
    }
})

router.post('/login',async(req,res)=>{
    const {email,password}=req.body;
    try{
        const user=await User.findOne({email});
        if(!user){
            return res.status(400).json({message: 'User not found'}); //kh tim thay
        }
        const isMatch=await bcrypt.compare(password,user.password);
        //nó sẽ so sánh mật khẩu thô với mật khẩu đã mã hoá(thư viện nó tự làm cho)
        if(!isMatch){
            return res.status(400).json({message: 'Invalid credentials'}); // khong hop le
        }
        const payload={user: {id: user.id}};
        const token=jwt.sign(payload,process.env.JWT_KEY,{expiresIn: '1h'});
        res.json({
            token,
            idUser:user.id});

    }catch(error){
        console.log(error);
    }
});


router.get('/get_all_user',authenticateToken,async(req,res)=>{
    try{
        const user=await User.find();
        res.status(200).json({
            status: 200,
            message: 'success get user',
            data: user
        })

    }catch(error){
        console.log(error);
    }
});

module.exports=router;