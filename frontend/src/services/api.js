const BASE_URL = "http://localhost:3000";

export const getNotifications = async () => {
  const res = await fetch(`${BASE_URL}/notifications`);
  return res.json();
};

export const getDashboardStats = async () => {
  const res = await fetch(`${BASE_URL}/dashboard/stats`);
  const data = await res.json();
  return {
    patientSatisfaction: data["Patient Satisfaction Score"],
    complaints: data["Number of Complaints"],
    avgLengthOfStay: data["Average Length of Stay"],
    careQualityScore: data["Care Quality Score"],
  };
};

export const getPatientOutcomes = async () => {
  const res = await fetch(`${BASE_URL}/dashboard/patient-outcomes`);
  return res.json();
};

export const getUnitSatisfaction = async () => {
  const res = await fetch(`${BASE_URL}/dashboard/unit-satisfaction`);
  return res.json();
};

export const getTrainingNeeds = async () => {
  const res = await fetch(`${BASE_URL}/dashboard/training-needs`);
  return res.json();
};