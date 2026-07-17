import { useState, useEffect } from "react";
import { invoke } from "@tauri-apps/api/core";
import "./App.css";

function App() {
	const [joint1, setJoint1] = useState(0);
	const [joint2, setJoint2] = useState(0);
	const [joint3, setJoint3] = useState(0);
	const [joint4, setJoint4] = useState(0);
	const [joint5, setJoint5] = useState(0);
	const [joint6, setJoint6] = useState(0);

	const [joint1Input, setJoint1Input] = useState("0");

	useEffect(() => {
		setJoint1Input(joint1.toString());
	}, [joint1]);

	const handleTextInput = (val: string) => {
		setJoint1Input(val); 

		if (val === "" || val === "-" || val === "-0") return;

		const num = Number(val);
		if (!isNaN(num) && num >= -180 && num <= 180) {
			updateJoint(1, num);
		}
	};


	const stateSetters: Record<number, (v: number) => void> = { 
    	1: setJoint1,
		2: setJoint2,
		3: setJoint3,
		4: setJoint4,
		5: setJoint5,
		6: setJoint6,
  	}

	async function updateJoint(jointId: number, angle: number) {	
		try {
			const returnAngle = await invoke<number>("set_joint", { jointId, angle});
			stateSetters[jointId](returnAngle);
		} catch(err) {
			console.error("Failed to move joint:", err);
		}

	}

	return (
		<main className="container">


			<div className="slider-container flex items-center gap-2">
				<label className="block text-sm font-medium text-heading">J1</label>
				<input 
					type="range"
					min="-180" 
					max="180" 
					value={joint1}
					onChange={(e) => updateJoint(1, Number(e.target.value))}
					className="w-100 mr-2 h-2 bg-white rounded-full appearance-none cursor-pointer"
				/>
				<div className="border-gray-50">
					<label>θ:</label> 
					<input 
						className="ml-1 w-[2.5rem]" 
						value={joint1Input} 
						onChange={(e) => handleTextInput(e.target.value)}
					/>
				</div>
			</div>


		</main>
	);
}

export default App;
