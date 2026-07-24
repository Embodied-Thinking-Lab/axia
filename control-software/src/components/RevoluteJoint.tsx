import { useRef } from "react";

interface revProps {
	r: number,
	alpha: number,
	d: number,
	theta: number,
}

export function RevoluteJoint({ r, alpha, d, theta } : revProps) {
	const joint = useRef(null);

	return (
		<group ref={joint} rotation={[0, 0, theta]}>
			<mesh>
				<cylinderGeometry args={[0.15, 0.15, 0.3, 32]}/>
				<meshStandardMaterial color="gray" />
			</mesh>

   			{/*<mesh position={[r / 2, 0, 0]}>
                <boxGeometry
                    args={[r, 0.1, 0.1]}
                />
                <meshStandardMaterial color="orange" />
            </mesh>*/}
		</group>
	)
}
