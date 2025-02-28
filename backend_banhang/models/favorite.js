const mongoose=require('mongoose');
const FavoriteSchema=new mongoose.Schema({
    userId:{type:mongoose.Schema.ObjectId,ref:'User',require:true},
    productId:{type:mongoose.Schema.ObjectId,ref:'Product',require},
},{
    timestamps:true,
})

const Favorite=mongoose.model('Favorite',FavoriteSchema);
module.exports=Favorite;