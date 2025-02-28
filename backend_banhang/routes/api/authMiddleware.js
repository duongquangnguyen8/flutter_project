const jwt=require('jsonwebtoken');
const express=require('express');
const router=express.Router();
const authenticateToken=(req,res,next)=>{
    const authHeader=req.headers['authorization']; //sử dụng một token để xác thực(lấy ở token ở authorization)
    const token=authHeader&&authHeader.split(' ')[1]; // tách từng phần tử thành mảng theo ' ' và lấy phần tử 1(token)

    if(token==null) return res.status(401).json({message: 'No token provided'});
     jwt.verify(token,process.env.JWT_KEY,(error,user)=>{
        if(error) {
            return res.status(403).json({message: 'Invalid token or token expired'})
        };
        req.user=user;
        next();
     })
    
}

module.exports=authenticateToken;
