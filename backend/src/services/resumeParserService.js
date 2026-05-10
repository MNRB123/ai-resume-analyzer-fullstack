import pdf from "pdf-parse"; import mammoth from "mammoth";
export const parseResumeFile = async (file)=>{ if(!file)return ""; const n=(file.originalname||"").toLowerCase(); if(n.endsWith(".pdf")) return (await pdf(file.buffer)).text||""; if(n.endsWith(".docx")) return (await mammoth.extractRawText({buffer:file.buffer})).value||""; return file.buffer.toString("utf-8"); };
