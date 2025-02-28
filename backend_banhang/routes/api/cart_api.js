const express=require('express');
const Cart = require('../../models/cart');
const router=express.Router();

router.post('/postCart',async(req,res)=>{
    try{
        const data=req.body;
        let cartItem=await Cart.findOne({userId:data.userId,productId:data.productId});

        if(cartItem){
            cartItem.quantity += data.quantity;
            cartItem.price += data.price;
            await cartItem.save();
            res.status(200).json({
                message:'Update quantity success',
                data: cartItem
            });
        }else{
            const newCart=new Cart({
                userId:data.userId,
                productId:data.productId,
                quantity:data.quantity,
                price:data.price
                });
        
                const result=await newCart.save();
                res.status(200).json({
                    message:'Post Cart success',
                    data: result 
                })
        }

    }catch(error){
        console.log(error);
        
    }
});
router.delete('/deleteCartById/:id',async (req,res)=>{
    try{
        const {id}=req.params;
        const result=await Cart.findByIdAndDelete(id);
        res.status(200).json({
            message:'Delete Cart success',
            data:result,
        })
    }catch(error){
        console.log(error);
        
    }

})
router.get('/getCartByUserId/:userId',async(req,res)=>{
    try{
        const {userId}=req.params;
        const data=await Cart.find({userId:userId})
        res.status(200).json({
            message:'Get Cart by userId success',
            data:data
        });

    }catch(error){
        console.log(error);
    }
})
module.exports=router;