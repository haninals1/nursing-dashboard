import { useState, useEffect } from "react";
import Layout from "../components/Layout";
import {
  LineChart,
  Line,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from "recharts";
import {
  LayoutDashboard,
  Bell,
  LogOut,
  TrendingDown,
  TrendingUp,
  Minus,
  Smile,
  AlertCircle,
  Activity,
  Hospital
} from "lucide-react";

import {
  getDashboardStats,
  getPatientOutcomes,
  getUnitSatisfaction,
  getTrainingNeeds,
} from "../services/api";

import "../styles/AssistantDirectorDashboard.css";
const logoPath = "/src/assets/logo.png"; // keeping placeholder logic

export default function AssistantDirectorDashboard() {
  const [activeTab, setActiveTab] = useState("dashboard");
  const [isLoading, setIsLoading] = useState(true);

  const [dashboardStats, setDashboardStats] = useState(null);
  const [outcomesData, setOutcomesData] = useState([]);
  const [unitData, setUnitData] = useState([]);
  const [trainingData, setTrainingData] = useState([]);

  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        setIsLoading(true);
        const [stats, outcomes, units, training] = await Promise.all([
          getDashboardStats(),
          getPatientOutcomes(),
          getUnitSatisfaction(),
          getTrainingNeeds(),
        ]);

        setDashboardStats(stats);
        setOutcomesData(outcomes);
        setUnitData(units);
        setTrainingData(training);
      } catch (err) {
        console.error("Error fetching dashboard data:", err);
        setError("Failed to fetch dashboard data. Please try again.");
      } finally {
        setIsLoading(false);
      }
    };

    fetchDashboardData();
  }, []);

  if (isLoading) {
    return (
      <div className="dashboard-container loading-state">
        <div className="spinner"></div>
        <p>Loading Dashboard...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="dashboard-container error-state">
        <p className="error-text">{error}</p>
      </div>
    );
  }

  return (
    <Layout role={user.role || "assistantDirector"} username={user.full_name} logoSrc="/src/assets/logo.png">
      <div className="dashboard-container">
        {/* Main Content */}
        <main className="main-content">
          <div className="dashboard-grid">
            {/* Top Stat Cards */}
            <div className="stats-row">
              <div className="stat-card">
                <div className="stat-header">
                  <div className="stat-icon dark-blue"><Smile size={20} /></div>
                  <span className="stat-title">Patient Satisfaction Score</span>
                </div>
                <h3 className="stat-value text-green">{dashboardStats?.patientSatisfaction || "N/A"}</h3>
                <div className="stat-wave-bg"></div>
              </div>

              <div className="stat-card">
                <div className="stat-header">
                  <div className="stat-icon dark-blue"><AlertCircle size={20} /></div>
                  <span className="stat-title">Number of Complaints</span>
                </div>
                <h3 className="stat-value text-red">{dashboardStats?.complaints ?? "N/A"}</h3>
                <div className="stat-wave-bg"></div>
              </div>

              <div className="stat-card">
                <div className="stat-header">
                  <div className="stat-icon dark-blue"><Activity size={20} /></div>
                  <span className="stat-title">Average Length of Stay</span>
                </div>
                <h3 className="stat-value text-blue">{dashboardStats?.avgLengthOfStay || "N/A"}</h3>
                <div className="stat-wave-bg"></div>
              </div>

              <div className="stat-card">
                <div className="stat-header">
                  <div className="stat-icon dark-blue"><Hospital size={20} /></div>
                  <span className="stat-title">Care Quality Score</span>
                </div>
                <h3 className="stat-value text-green">{dashboardStats?.careQualityScore || "N/A"}</h3>
                <div className="stat-wave-bg"></div>
              </div>
            </div>

            {/* Middle Row: Satisfaction Bar & Outcomes Chart */}
            <div className="charts-row">
              <div className="chart-card satisfaction-card">
                <h3 className="card-title">Overall Satisfaction Rate</h3>

                <div className="satisfaction-bar-container">
                  <div className="satisfaction-bar">
                    <div className="bar-segment negative" style={{ width: "15%" }}></div>
                    <div className="bar-segment neutral" style={{ width: "25%" }}></div>
                    <div className="bar-segment positive" style={{ width: "60%" }}></div>
                  </div>

                  <div className="satisfaction-legend-container">
                    <div className="legend-col">
                      <span className="legend-label">Negative</span>
                      <div className="legend-val">
                        <Smile className="text-red" size={16} />
                        <span>{dashboardStats?.satisfactionBreakdown?.negative || "16"}</span>
                      </div>
                    </div>
                    <div className="legend-col">
                      <span className="legend-label">Neutral</span>
                      <div className="legend-val">
                        <Smile className="text-yellow" size={16} />
                        <span>{dashboardStats?.satisfactionBreakdown?.neutral || "45"}</span>
                      </div>
                    </div>
                    <div className="legend-col">
                      <span className="legend-label">Positive</span>
                      <div className="legend-val">
                        <Smile className="text-green" size={16} />
                        <span>{dashboardStats?.satisfactionBreakdown?.positive || "2,113"}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div className="chart-card outcomes-card">
                <div className="chart-wrapper">
                  <ResponsiveContainer width="100%" height={260}>
                    <LineChart data={outcomesData} margin={{ top: 20, right: 20, left: 0, bottom: 0 }}>
                      <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="rgba(255,255,255,0.2)" />
                      <XAxis
                        dataKey="month"
                        tick={{ fill: "#475569", fontSize: 11 }}
                        axisLine={{ stroke: "rgba(255,255,255,0.2)" }}
                        tickLine={false}
                      />
                      <YAxis
                        tick={{ fill: "#475569", fontSize: 11 }}
                        axisLine={false}
                        tickLine={false}
                        label={{ value: 'Incidents per 1000\npatient days (0-6)', angle: -90, position: 'insideLeft', fill: "#475569", fontSize: 10, offset: 0 }}
                        domain={[0, 10]}
                        ticks={[0, 2, 4, 6, 8, 10]}
                      />
                      <Tooltip contentStyle={{ borderRadius: "8px", border: "none", backgroundColor: "#fff", color: "#333" }} />
                      <Legend verticalAlign="top" wrapperStyle={{ paddingBottom: "20px", fontSize: "11px", color: "#475569" }} iconType="circle" iconSize={8} />
                      <Line type="monotone" dataKey="fallRate" name="Fall Rate" stroke="#ff4d4f" strokeWidth={2} dot={{ r: 4, fill: "#ff4d4f" }} />
                      <Line type="monotone" dataKey="medicationErrors" name="Medication Errors" stroke="#8b5cf6" strokeWidth={2} dot={{ r: 4, fill: "#8b5cf6" }} />
                      <Line type="monotone" dataKey="pressureInjuries" name="Pressure Injuries" stroke="#fbbf24" strokeWidth={2} dot={{ r: 4, fill: "#fbbf24" }} />
                    </LineChart>
                  </ResponsiveContainer>
                </div>
              </div>
            </div>

            {/* Bottom Row: Training Needs & Unit Table */}
            <div className="charts-row">
              <div className="chart-card training-card">
                <h3 className="card-title">Training Needs Analysis</h3>

                <div className="training-overlay-stats">
                  <div className="t-stat">
                    <span className="t-label">Units Overstaffed</span>
                    <span className="t-val text-red">4</span>
                    <div className="t-wave"></div>
                  </div>
                  <div className="t-stat">
                    <span className="t-label">Units Understaffed</span>
                    <span className="t-val text-red">2</span>
                    <div className="t-wave"></div>
                  </div>
                  <div className="t-stat">
                    <span className="t-label">Overtime Hours</span>
                    <span className="t-val text-yellow">14 hrs</span>
                    <div className="t-wave"></div>
                  </div>
                </div>

                <div className="chart-wrapper training-chart-wrapper">
                  <ResponsiveContainer width="100%" height={280}>
                    <BarChart data={trainingData} layout="vertical" margin={{ top: 20, right: 20, left: 60, bottom: 20 }} barCategoryGap={10}>
                      <CartesianGrid strokeDasharray="3 3" horizontal={false} vertical={true} stroke="rgba(255,255,255,0.2)" />
                      <XAxis
                        type="number"
                        tick={{ fill: "#475569", fontSize: 10 }}
                        axisLine={false}
                        tickLine={false}
                        domain={[0, 100]}
                        ticks={[0, 20, 40, 60, 80, 100]}
                        orientation="top"
                      />
                      <YAxis
                        dataKey="topic"
                        type="category"
                        tick={{ fill: "#475569", fontSize: 10 }}
                        axisLine={false}
                        tickLine={false}
                        width={110}
                      />
                      <Tooltip cursor={{ fill: "rgba(255,255,255,0.1)" }} contentStyle={{ borderRadius: "8px" }} />
                      <Legend verticalAlign="bottom" wrapperStyle={{ paddingTop: "10px", fontSize: "10px", color: "#475569" }} iconType="circle" iconSize={6} />
                      <Bar dataKey="score" name="Shortage Rate" fill="#818cf8" barSize={16} radius={[0, 4, 4, 0]} />
                    </BarChart>
                  </ResponsiveContainer>
                </div>
              </div>

              <div className="chart-card table-card">
                <h3 className="card-title text-center">Unit Satisfaction Levels</h3>
                <div className="table-responsive">
                  <table className="unit-table">
                    <thead>
                      <tr>
                        <th><div className="th-pill">Unit</div></th>
                        <th><div className="th-pill">Satisfaction</div></th>
                        <th><div className="th-pill">Trend</div></th>
                      </tr>
                    </thead>
                    <tbody>
                      {unitData.map((row) => (
                        <tr key={row.unit}>
                          <td><div className="td-pill dark-pill">{row.unit}</div></td>
                          <td><div className="td-pill dark-pill">{row.score}%</div></td>
                          <td>
                            {row.trend === "up" && <div className="td-pill trend-pill positive-bg text-green"><TrendingUp size={20} strokeWidth={2.5} /></div>}
                            {row.trend === "down" && <div className="td-pill trend-pill negative-bg text-red"><TrendingDown size={20} strokeWidth={2.5} /></div>}
                            {row.trend === "neutral" && <div className="td-pill trend-pill neutral-bg text-yellow"><Minus size={20} strokeWidth={2.5} /></div>}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </Layout>
  );
}
const user = JSON.parse(localStorage.getItem("user") || "{}");