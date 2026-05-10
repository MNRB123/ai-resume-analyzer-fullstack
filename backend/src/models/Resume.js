import mongoose from "mongoose";
export const Resume = mongoose.model("Resume", new mongoose.Schema({userId:mongoose.Schema.Types.ObjectId,rawText:String,sourceType:String,fileName:String},{timestamps:true}));
