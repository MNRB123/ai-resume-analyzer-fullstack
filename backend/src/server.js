import "dotenv/config"; import express from "express"; import cors from "cors";
import { connectDB } from "./config/db.js"; import { initVectorStore } from "./services/ragService.js";
import authRoutes from "./routes/authRoutes.js"; import analysisRoutes from "./routes/analysisRoutes.js";
const app=express(); app.use(express.json({limit:"5mb"})); app.use(cors({origin:process.env.FRONTEND_URL||"*"}));
app.get("/api/health",(_q,s)=>s.json({ok:true})); app.use("/api/auth",authRoutes); app.use("/api/analysis",analysisRoutes);
const port=process.env.PORT||5000; (async()=>{try{await connectDB(); await initVectorStore(); app.listen(port,()=>console.log(`Server running on http://localhost:${port}`));}catch(e){console.error("Startup failed",e);process.exit(1);}})();
