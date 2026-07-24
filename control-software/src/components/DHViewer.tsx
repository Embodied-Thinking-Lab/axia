import { RevoluteJoint } from "./RevoluteJoint"

export function DHViewer({ linkTransforms, positions, endEffector, toolInterface}) {

	const eePos: [number, number, number] = [endEffector[3], endEffector[7], endEffector[11]];
	return (
		<group>
			<RevoluteJoint
				transform={[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
				start={[0, 0, 0]}
				end={[positions[1].x, positions[1].y, positions[1].z]}
			/>
			{linkTransforms.map((matrix, i: number) => {
				const nextPos = positions[i + 1];
				const currentPos = positions[i];
				return (
					<RevoluteJoint
						key={i}
						transform={matrix}
						start={[currentPos.x, currentPos.y, currentPos.z]}
						end={[
							nextPos ? nextPos.x : currentPos.x,
							nextPos ? nextPos.y : currentPos.y,
							nextPos ? nextPos.z : currentPos.z - toolInterface.z,
						]}
					/>
				)
			})}
			<mesh position={eePos}>
				<sphereGeometry args={[10, 10, 20]}/>
				<meshStandardMaterial color="red" />
			</mesh>
		</group>
	)
}
