import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "./pages/Login.jsx";
import AssistantDirectorDashboard from "./pages/AssistantDirectorDashboard.jsx";
import "./App.css";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/dashboard" element={<AssistantDirectorDashboard />} />
      </Routes>
    </Router>
  );
}

export default App;