import { useState, useEffect } from "react";
import { invoke } from "@tauri-apps/api/core";
import "./App.css";
import { JointSlider } from "./components/JointSlider";

interface JointConstraints {
	min: number;
	max: number;
}

interface Vector3 {
	x: number,
	y: number,
	z: number,
}

function App() {
	const [joint1, setJoint1] = useState(0);
	const [joint2, setJoint2] = useState(0);
	const [joint3, setJoint3] = useState(0);
	const [joint4, setJoint4] = useState(0);
	const [joint5, setJoint5] = useState(0);
	const [joint6, setJoint6] = useState(0);

	const [jointAngles, setJointAngles] = useState<number[]>([0,0,0,0,0,0]);

	const [fkMatrix, setFkMatrix] = useState<number[]>([]);

	const defaultPositions: Vector3[] = [
        { x: 0, y: 0, z: 0 },
        { x: 0, y: 0, z: 0 },
        { x: 0, y: 0, z: 0 },
        { x: 0, y: 0, z: 0 },
        { x: 0, y: 0, z: 0 },
        { x: 0, y: 0, z: 0 },
        { x: 0, y: 0, z: 0 },
    ];

	const tiVector: Vector3 = { x: 0, y: 0, z: 90 };

	const stateSetters: Record<number, (v: number) => void> = { 
    	1: setJoint1,
		2: setJoint2,
		3: setJoint3,
		4: setJoint4,
		5: setJoint5,
		6: setJoint6,
  	}

	const jointValues: Record<number, number> = {
		1: joint1,
		2: joint2,
		3: joint3,
		4: joint4,
		5: joint5,
		6: joint6,
	}

	const jointConstraints: JointConstraints[] = [
		{min: -180, max: 180},
		{min: -180, max: 180},
		{min: -180, max: 180},
		{min: -180, max: 180},
		{min: -180, max: 180},
		{min: -180, max: 180},
	]

	const defaultJointAngles: Record<number, number> = {
		1: 0,
		2: 0,
		3: 0,
		4: 0,
		5: 0,
		6: 0,
	}

	const resetJoints = () => {
		for (let id = 1; id <= 6; id++) {
       		updateJoint(id, defaultJointAngles[id]);
    	}
	}

	async function updateJoint(jointId: number, angle: number) {	
		try {
			const returnAngle = await invoke<number>("set_joint", { jointId, angle});
			await updateFK();
			stateSetters[jointId](returnAngle);
		} catch(err) {
			console.error("Failed to move joint:", err);
		}
	}

	async function updateFK() {
		try {
			const resMat = await invoke<number[]>("calculate_fk", {
				joints: jointAngles,
				positions: defaultPositions,
				tiVector: tiVector,
			});

			setFkMatrix(resMat);
	
			console.log("C FK OUTPUT (4x4):");
			for (let i = 0; i < 4; i++) {
				const row = resMat
					.slice(i * 4, i * 4 + 4)
					.map((val) => val.toFixed(3).padStart(8, " "))
					.join(" ");
				console.log(`[ ${row} ]`);
			}
		} catch(err) {
			console.log("Failed to compute FK:", err);
		}
	}

	return (
		<main className="flex gap-1 ">
			<div>
				{[1, 2, 3, 4, 5, 6].map((id) => (
					<JointSlider
						key={id}
						jointId={id}
						label={`J${id}`}
						value={jointValues[id]}
						min={jointConstraints[id-1].min}
						max={jointConstraints[id-1].max}
						onChange={updateJoint}

					/>
				))}
			</div>
		
			<button 
				type="button" 
				className="
				text-red-700 bg-neutral-primary border hover:border-red-700 
				hover:bg-red-700 hover:text-white rounded-sm font-medium leading-5 
				rounded-base text-sm px-3 py-2 focus:outline-none cursor-pointer
				"
				onClick={() => {
					resetJoints();
					updateFK();
				}}
			>
					Reset
			</button>
		</main>
	);
}

export default App;
