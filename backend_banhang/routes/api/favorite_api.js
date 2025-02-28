const express=require('express');
const { route } = require('./category_api');
const Favorite = require('../../models/favorite');
const authenticateToken=require('../api/authMiddleware');
const router=express.Router();

router.post('/post_favorite',async(req,res)=>{
    const data=req.body;
    try{
        const newFavorite=new Favorite({
            userId:data.userId,
            productId:data.productId,
        });
        await newFavorite.save();
        res.status(200).json({
            message:'post favorite success',
            data: newFavorite,
        })
    }catch(error){
        console.log(error);
        
    }}
);
router.delete('/delete_favorite_byId/:id',async(req,res)=>{
    try{
        const {id}=req.params;
        const data=await Favorite.findByIdAndDelete(id);
        res.status(200).json({
            message:'delete favorite success',
            data: data
        })
        
    }catch(error){
        console.log((error));
        
    }
});
router.post('/getIdFavorite',async(req,res)=>{
    try{
        const {userId,productId}=req.body;
        const data=await Favorite.findOne({productId:productId,userId:userId});
        res.status(200).json({
            message:'success id favorite',
            data: data
        })

    }catch(error){
        console.log(error);
        
    }
})

router.get('/get_favorite_by_userId/:userId',authenticateToken,async(req,res)=>{
    try{
        const {userId}=req.params;
        
        const result=await Favorite.find({userId:userId});
        res.status(200).json({
            message:'get favorite success',
            data: result,
        })
    }catch(error){
        console.log(error);
        
    }
});
router.post('/get_favorite_productDetail',authenticateToken,async(req,res)=>{

    try{
        const {userId,productId}=req.body;
        const data=await Favorite.find({userId:userId,productId:productId});
        if (data.length > 0) {
            res.status(200).json({
              message: 'success favorite product detail found',
              data: data
            });
          } 
        else{
            console.log('not found favorite');
        }
    }catch(error){
        console.log(error);
        
    }
})
module.exports=router;