const mongoose=require('mongoose');

const userSchema=new mongoose.Schema({
    email:{type: String, require: true, unique:true},
    password:{type:String, require: true},
    fullName: {type: String},
    address: {type:String},
    phoneNumber:{type:String},
    birth: {type: Date},
    role:{type: String},
    otp:{type: String},
    otpExpires:{type: Date},
},{
    timestamps: true,
});
const User=mongoose.model('User',userSchema);
module.exports=User;