import "./../styles/personalInfo.css";

const nurses = [
    {
        name: "Sarah Ali",
        iqama: "1122338811",
        jobTitle: "Nursing Specialist",
        position: "Assistant Head Nurse",
        unit: "OPD",
        status: "Active",
    },
    {
        name: "Mona Anwar",
        iqama: "1122338811",
        jobTitle: "Midwifery Technician",
        position: "Staff Nurse",
        unit: "ER",
        status: "EOC",
    },
    {
        name: "Saad Omar",
        iqama: "1122338811",
        jobTitle: "Nursing Technician",
        position: "Staff Nurse",
        unit: "OR",
        status: "Transferred",
    },
    {
        name: "Nawaf Ahmed",
        iqama: "1122338811",
        jobTitle: "Nursing Specialist",
        position: "Nurse Assistant",
        unit: "2BWN",
        status: "Active",
    },
    {
        name: "Zainab Ali",
        iqama: "1122338811",
        jobTitle: "Midwifery Technician",
        position: "Assistant Head Nurse",
        unit: "2C",
        status: "EOC",
    },
];

export default function PersonalInfo() {
    return (
        <div className="personal-page">
            {/* Top Bar */}
            <div className="topbar">
                <h1>Personal info</h1>
            </div>

            <div className="page-body">
                {/* Sidebar */}
                <aside className="sidebar">
                    <div className="sidebar-logo">
                        <img src="/logo-placeholder.png" alt="logo" />
                    </div>

                    <nav className="sidebar-menu">
                        <button className="menu-item active">Personal info</button>
                        <button className="menu-item">Dashboard</button>
                        <button className="menu-item">Notifications</button>
                        <button className="menu-item">Request</button>
                    </nav>

                    <button className="logout-btn">Log out</button>
                </aside>

                {/* Main Content */}
                <main className="content">
                    {/* Filters */}
                    <div className="filters">
                        <div className="filter-group">
                            <label>Unit</label>
                            <select>
                                <option>All</option>
                                <option>OPD</option>
                                <option>ER</option>
                                <option>OR</option>
                            </select>
                        </div>

                        <div className="filter-group">
                            <label>Degree</label>
                            <select>
                                <option>All</option>
                                <option>Bachelor</option>
                                <option>Diploma</option>
                                <option>Master</option>
                            </select>
                        </div>
                    </div>

                    {/* Table Card */}
                    <section className="table-card">
                        <div className="table-header">
                            <h2>Nurses informations</h2>
                            <button className="add-btn">Add new Nurse Record +</button>
                        </div>

                        <table>
                            <thead>
                                <tr>
                                    <th>Names</th>
                                    <th>Iqama</th>
                                    <th>Hospital Job Title</th>
                                    <th>Position</th>
                                    <th>Unit</th>
                                    <th>Job Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {nurses.map((nurse, index) => (
                                    <tr key={index}>
                                        <td>{nurse.name}</td>
                                        <td>{nurse.iqama}</td>
                                        <td>{nurse.jobTitle}</td>
                                        <td>{nurse.position}</td>
                                        <td>{nurse.unit}</td>
                                        <td>
                                            <span className={`status ${nurse.status.toLowerCase()}`}>
                                                {nurse.status}
                                            </span>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </section>
                </main>
            </div>
        </div>
    );
}
