import OpenAI from "openai";
const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
export const getEmbedding = async (text)=> (await client.embeddings.create({model:process.env.OPENAI_EMBEDDING_MODEL||"text-embedding-3-small",input:text.slice(0,8000)})).data[0].embedding;
export const getStructuredAnalysis = async ({resumeText,jdText,targetRole,skillGap,retrievedContext})=>{
  const prompt=`Return strict JSON with keys: jobMatchScore,atsKeywords,strengths,weaknesses,improvementTips,portfolioSuggestions,summary.
Role:${targetRole}
Resume:${resumeText.slice(0,5000)}
JD:${jdText.slice(0,5000)}
Matched:${skillGap.matched.join(",")}
Missing:${skillGap.missing.join(",")}
Context:${retrievedContext.slice(0,1500)}`;
  const r=await client.chat.completions.create({model:process.env.OPENAI_MODEL||"gpt-4o-mini",temperature:0.2,response_format:{type:"json_object"},messages:[{role:"user",content:prompt}]});
  return JSON.parse(r.choices[0].message.content||"{}");
};
