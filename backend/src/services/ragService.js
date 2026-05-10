const mem=[]; const provider=(process.env.VECTOR_PROVIDER||"in_memory").toLowerCase();
export const initVectorStore=async()=>console.log(`Vector store ready: ${provider}`);
export const getVectorStatus=async()=>({ok:true,provider,details:{mode:provider}});
const cos=(a,b)=>{const d=a.reduce((s,x,i)=>s+x*b[i],0),na=Math.sqrt(a.reduce((s,x)=>s+x*x,0)),nb=Math.sqrt(b.reduce((s,x)=>s+x*x,0)); return (!na||!nb)?0:d/(na*nb);};
export const upsertVectors=async({id,text,embedding,metadata={}})=>{const i=mem.findIndex(x=>x.id===id);const v={id,text,embedding,metadata}; if(i>=0)mem[i]=v; else mem.push(v);};
export const querySimilarContext=async({embedding,topK=3})=>mem.map(x=>({...x,s:cos(x.embedding,embedding)})).sort((a,b)=>b.s-a.s).slice(0,topK).map(x=>x.text).join("\n---\n");
