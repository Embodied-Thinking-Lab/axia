import { useState, useEffect, useCallback, useMemo } from "react";
import { invoke } from "@tauri-apps/api/core";
import "./App.css";
import { JointSlider } from "./components/JointSlider";
import { AxisInput } from "./components/AxisInput";
import { DHInputField } from "./components/DHInputField";
import { JointConstraints, Vector3 } from "./props"
// import ModelViewer from "./components/ModelViewer"
import { DHViewer } from "./components/DHViewer";
import { Canvas } from "@react-three/fiber";
import { OrbitControls } from "@react-three/drei";




function App() {

	type FKResult = [
	    Vector3[],
	    number[][],
	    number[]
	];
	// type declerations
	// positions[7]
	// type SevenVectors = [ Vector3, Vector3, Vector3, Vector3, Vector3, Vector3, Vector3 ]
	// dh_params[6][4]
	// type DHRow = [number, number, number, number];


	const degToRad = (degrees: number): number => {
  		return degrees * (Math.PI / 180);
	};


	// const declerations
	const [jointAngles, setJointAngles] = useState([0,0,0,0,0,0]);
	const [tiVector, setTIVector] = useState<Vector3>({ x:0, y:0, z:90 });
	const axes = Object.keys(tiVector) as Array<keyof Vector3>;
	const [fkMatrix, setFkMatrix] = useState<number[]>([]);
	const [dhParams, setDHParams] = useState([
		[0, degToRad(0), 87, degToRad(jointAngles[0])],
    	[0, degToRad(90), 97, degToRad(jointAngles[1])],
    	[280, degToRad(0), 0, degToRad(jointAngles[2] + 90)],
    	[0, degToRad(-90), 25.5, degToRad(jointAngles[3])],
    	[0, degToRad(-90), 220.5, degToRad(jointAngles[4])],
    	[0, degToRad(90), 70, degToRad(jointAngles[5] - 90)]
	])
	const [visualDHParams, setVisualDHParams] = useState([
		[0, 0, 87, jointAngles[0]],
    	[0, 90, 97, jointAngles[1]],
    	[280, 0, 0, jointAngles[2] + 90],
    	[0, -90, 25.5, jointAngles[3]],
    	[0, -90, 220.5, jointAngles[4]],
    	[0, 90, 70, jointAngles[5] - 90]
	])

	const [positions, setPositions] = useState<Vector3[]>();
	const [linkTransformations, setLinkTransformations] = useState<number[][]>();
	const [endEffector, setEndEffector] = useState<number[]>();

	const defaultPositions = useMemo(() => [
	  	{ x: 0, y: 0, z: 0 },
	  	{ x: 0, y: 0, z: 0 },
	  	{ x: 0, y: 0, z: 0 },
	  	{ x: 0, y: 0, z: 0 },
	  	{ x: 0, y: 0, z: 0 },
	  	{ x: 0, y: 0, z: 0 },
	  	{ x: 0, y: 0, z: 0 },
	], [])
	const jointConstraints: JointConstraints[] = [
		{min: -180, max: 180},
		{min: -180, max: 180},
		{min: -180, max: 180},
		{min: -180, max: 180},
		{min: -180, max: 180},
		{min: -180, max: 180},
	]

	const updateFK = useCallback(async (currentPositions = defaultPositions, currentTI = tiVector, currentDHParams = dhParams) => {
		try {
			// console.log(JSON.stringify(currentPositions));
			const [pos, links, ee] = await invoke<FKResult>("calculate_fk", {
				positions: currentPositions,
				tiVector: currentTI,
				dhParams: currentDHParams,
			});
			setPositions(pos);
			setLinkTransformations(links)
			setEndEffector(ee);
		} catch(err) {
			console.log("Failed to compute fk", err);
		}
	}, [defaultPositions, tiVector, dhParams])

	useEffect(() => {
		updateFK(defaultPositions, tiVector, dhParams);
	}, [tiVector, dhParams]);

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

	const updateVisualDH = (row: number, col: number, value: number) => {
    	setVisualDHParams(prev =>
        	prev.map((r, i) =>
            	i === row
                ? r.map((v, j) => (j === col ? value : v))
                : r
        	)
		);
		updateDH();
	};

	function updateDH() {
		setDHParams(
			visualDHParams.map((row) =>
				row.map((cell, j) =>
					j === 1 || j === 2
						? degToRad(cell)
						: cell
				)
			)
		)
	}
	const homeJoints = async () => {
		const homed = [0, 0, 0, 0, 0, 0];
		setJointAngles(homed);
		await Promise.all(
			[1, 2, 3, 4, 5, 6].map((id) => invoke("set_joint", { jointId: id, angle: 0 }))
    	);
        updateFK(homed, tiVector);
	}

	const pos: [number, number, number] = [endEffector[3], endEffector[7], endEffector[11]]

	return (
		<main className="flex gap-1 flex-row w-100vw h-100vh">
			<div className="w-[100vw] h-[100vh]">
				<Canvas camera={{ position: [600, 600, 600], fov: 60, near: 0.1, far: 5000 }}>
					<ambientLight intensity={1} />
				    <directionalLight position={[5, 5, 5]} />

				    <gridHelper args={[1000, 20]} />
					<axesHelper args={[50]} />


					<group rotation={[-Math.PI / 2, 0, Math.PI / 2]}>
						<mesh rotation={[-Math.PI / 2, 0, 0]}>
							<cylinderGeometry args={[10, 10, 20, 32]}/>
							<meshStandardMaterial color="gray" />
						</mesh>
						<DHViewer linkTransforms={linkTransformations} />
						<mesh position={pos}>
							<sphereGeometry args={[10, 10, 20]}/>
							<meshStandardMaterial color="red" />
						</mesh>
					</group>

				    <OrbitControls target={[0, 0, 230]} />
				</Canvas>
			</div>
			<div className="flex gap-1 flex-col w-max">


				Tool Interface Vector:
				<div className="w-[5rem] flex flex-row gap-2">
					{axes.map((axis) => (
						<AxisInput
							label={`${axis.toUpperCase()}:`}
							key={axis}
							type={axis}
							value={tiVector[axis]}
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
					}}
				>
						HOME JOINTS
				</button>

				Denavit-Hartenberg Parameters
				<div className="grid grid-cols-4">
				{visualDHParams.map((row, i) => (
					row.map((value, j) => (
					<DHInputField
						key={j}
						styling={"w-[4rem] border border-gray-800 rounded-sm px-1"}
						row={i}
						col={j}
						value={value}
						onChange={updateVisualDH}
					/>
					))
				))}
				</div>

			</div>
		</main>
	);
}

export default App;
