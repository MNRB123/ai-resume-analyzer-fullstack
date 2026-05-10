import mongoose from "mongoose";
export const Analysis = mongoose.model("Analysis", new mongoose.Schema({userId:mongoose.Schema.Types.ObjectId,resumeId:mongoose.Schema.Types.ObjectId,jobDescriptionId:mongoose.Schema.Types.ObjectId,targetRole:String,result:Object},{timestamps:true}));
