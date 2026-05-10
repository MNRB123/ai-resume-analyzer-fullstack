import mongoose from "mongoose";
export const JobDescription = mongoose.model("JobDescription", new mongoose.Schema({userId:mongoose.Schema.Types.ObjectId,title:String,content:String},{timestamps:true}));
