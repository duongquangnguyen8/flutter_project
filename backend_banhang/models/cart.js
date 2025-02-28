const mongoose=require('mongoose');

const cartSchema=new mongoose.Schema({
    userId:{type:mongoose.Schema.ObjectId,ref:'User',require:true},
    productId:{type:mongoose.Schema.ObjectId,ref:'Product',require:true},
    quantity:{type:Number},
    price: {type: Number}
});
const Cart=mongoose.model('Cart',cartSchema);
module.exports=Cart;