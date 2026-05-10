const API_BASE = process.env.NEXT_PUBLIC_API_BASE_URL || "http://localhost:5000";
export const api = {
  register: async (p)=> (await fetch(`${API_BASE}/api/auth/register`,{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify(p)})).json(),
  login: async (p)=> (await fetch(`${API_BASE}/api/auth/login`,{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify(p)})).json(),
  vectorStatus: async (t)=> (await fetch(`${API_BASE}/api/analysis/vector-status`,{headers:{Authorization:`Bearer ${t}`}})).json(),
  analyze: async ({token,targetRole,jobDescription,resumeText,resumeFile})=>{const f=new FormData();f.append("targetRole",targetRole);f.append("jobDescription",jobDescription);if(resumeText)f.append("resumeText",resumeText);if(resumeFile)f.append("resumeFile",resumeFile); return (await fetch(`${API_BASE}/api/analysis/run`,{method:"POST",headers:{Authorization:`Bearer ${token}`},body:f})).json();}
};
