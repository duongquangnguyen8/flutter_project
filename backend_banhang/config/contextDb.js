const mongoose=require('mongoose');
const mongoUri='mongodb://127.0.0.1:27017/ban_hang';

const connect=async ()=>{
    try{
        await mongoose.connect(mongoUri,{
            useNewUrlParser: true,
            useUnifiedTopology: true,
        });
        console.log('Kết nối thành công');
    }catch(error){
        console.log('Kết nối thất bại',error);
    }
}

module.exports={connect};