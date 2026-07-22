import { useState, useEffect, useCallback } from "react";
import { invoke } from "@tauri-apps/api/core";
import "./App.css";
import { JointSlider } from "./components/JointSlider";
import { InputField } from "./components/InputField";
import { JointConstraints, Vector3 } from "./props"



function App() {
	const [jointAngles, setJointAngles] = useState<number[]>([0,0,0,0,0,0]);
	const [TIVector, setTIVector] = useState<Vector3>({ x:0, y:0, z:90 });
	const axes = Object.keys(TIVector) as Array<keyof Vector3>;

	const [fkMatrix, setFkMatrix] = useState<number[]>([]);

	const defaultPositions: Vector3[] = Array(7).fill({ x: 0, y: 0, z: 0 })

	const jointConstraints: JointConstraints[] = [
		{min: -180, max: 180},
		{min: -180, max: 180},
		{min: -180, max: 180},
		{min: -180, max: 180},
		{min: -180, max: 180},
		{min: -180, max: 180},
	]

	const defaultJointAngles: Record<number, number> = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0 }

	const updateFK = useCallback(async (currentJoints = jointAngles, currentTI = TIVector) => {
		try {
			const resMat = await invoke<number[]>("calculate_fk", {
				joints: currentJoints,
				positions: defaultPositions,
				tiVector: currentTI,
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
	}, [jointAngles, TIVector])


	useEffect(() => {
		updateFK(jointAngles, TIVector);
	}, [jointAngles, TIVector]);


	function updateTIVector(axis: keyof Vector3, val: number) {
		setTIVector((prev) => ({ ...prev, [axis]: val}));
	}

	async function updateJoint(jointId: number, angle: number) {	
		try {
			const returnAngle = await invoke<number>("set_joint", { jointId, angle});
			updateFK();
			setJointAngles((prevJointAngles) => {
				const updated = [...prevJointAngles];
				updated[jointId-1] = returnAngle;
				return updated;
			})	
		} catch(err) {
			console.error("Failed to move joint:", err);
		}
	}

	const homeJoints = async () => {
		const homed = [0, 0, 0, 0, 0, 0];
		setJointAngles(homed);
		await Promise.all(
			[1, 2, 3, 4, 5, 6].map((id) => invoke("set_joint", { jointId: id, angle: 0 }))
    	);
        updateFK(homed, TIVector);
	}

	return (
		<main className="flex gap-1 flex-row w-max">
			<div></div>
			<div className="flex gap-1 flex-col w-max">


				Tool Interface Vector:	
				<div className="w-[5rem] flex flex-row gap-2"> 	
					{axes.map((axis) => (
						<InputField
							label={`${axis.toUpperCase()}:`}
							key={axis}	
							type={axis}
							value={TIVector[axis]}
							onChange={updateTIVector} 
						/>
					))}
					
				</div>


				Joint Jogging:
				<div>
					{[1, 2, 3, 4, 5, 6].map((id) => (
						<JointSlider
							key={id}
							jointId={id}
							label={`J${id}`}
							value={jointAngles[id-1]}
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
					w-max
					"
					onClick={() => {
						homeJoints();
						updateFK();
					}}
				>
						HOME JOINTS
				</button>

			</div>
		</main>
	);
}

export default App;
