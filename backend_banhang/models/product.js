const mongoose=require('mongoose');
const ProductSchema=new mongoose.Schema({
    productName:{type:String,require:true },
    description:{type: String},
    price: {type: Number},
    image: {type: String},
    categoryId:{type:mongoose.Schema.ObjectId,ref:'Category',require:true},
});

const Product=mongoose.model('Product',ProductSchema);
module.exports=Product;