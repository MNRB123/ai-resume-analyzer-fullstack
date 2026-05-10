import mongoose from "mongoose";
export const User = mongoose.model("User", new mongoose.Schema({name:String,email:{type:String,unique:true},passwordHash:String},{timestamps:true}));
