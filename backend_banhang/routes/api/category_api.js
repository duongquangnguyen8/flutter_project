const express=require('express');
const router=express.Router();
const  Category=require('../../models/category');

router.post('/post_category',async(req,res)=>{
    const data=req.body;
    try{
        const newCategory=new Category({
            categoryName: data.categoryName
        });
        await newCategory.save();
        res.status(200).json({
            message:'Post Category successfully',
            data: newCategory,
        })
    }catch(error){
        console.log(error);
    }
});
module.exports=router;