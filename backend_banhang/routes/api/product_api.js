const express=require('express');
const router=express.Router();
const jwt=require('jsonwebtoken');
const Product=require('../../models/product');
const authenticateToken=require('./authMiddleware');
router.post('/post_product',async(req,res)=>{
    const data=req.body;
    try{
        const newProduct=new Product({
            productName:data.productName,
            description:data.description,
            price:data.price,
            image:data.image,
            categoryId:data.categoryId,
        });
        const result=await newProduct.save();
        
        res.status(200).json({
            message:'post product successfully',
            data:result,
        })

    }catch(error){
        console.log(error);
    }
});
router.get('/get_all_product',authenticateToken,async(req,res)=>{
    try{
        const result=await Product.find();
        res.status(200).json({
            message:'get product successfully',
            data: result,
        })

    }catch(error){
        console.log(error);
        
    }
});
router.get('/getProductById/:id',async(req,res)=>{
    try{
        const {id}=req.params;
        const result=await Product.findById(id);
        res.status(200).json({
            message:'get product successfully',
            data: result,
        })
    }catch(error){
        console.log(error);
        
    }
})
module.exports=router;