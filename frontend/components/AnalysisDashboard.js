"use client";
export default function AnalysisDashboard({score,skillGap,atsKeywords,strengths,weaknesses,improvementTips,portfolioSuggestions,summary}) {
return <div className="card"><h2>Analysis Results</h2><p><b>Job Match Score:</b> {score}/100</p><p>{summary}</p>
<p><b>Matched:</b> {(skillGap?.matched||[]).join(", ")||"None"}</p><p><b>Missing:</b> {(skillGap?.missing||[]).join(", ")||"None"}</p>
<p><b>ATS Keywords:</b> {(atsKeywords||[]).join(", ")}</p><p><b>Strengths:</b> {(strengths||[]).join(" | ")}</p><p><b>Weaknesses:</b> {(weaknesses||[]).join(" | ")}</p>
<p><b>Tips:</b> {(improvementTips||[]).join(" | ")}</p><p><b>Portfolio:</b> {(portfolioSuggestions||[]).join(" | ")}</p></div>; }
