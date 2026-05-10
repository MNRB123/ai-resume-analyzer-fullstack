import jwt from "jsonwebtoken";
export const authRequired = (req,res,next)=>{ const t=req.headers.authorization?.split(" ")[1]; if(!t)return res.status(401).json({message:"Unauthorized"}); try{req.user=jwt.verify(t,process.env.JWT_SECRET); next();}catch{return res.status(401).json({message:"Invalid token"});} };
