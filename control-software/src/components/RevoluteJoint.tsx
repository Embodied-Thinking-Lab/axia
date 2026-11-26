import { useMemo, useRef } from "react";
import * as THREE from "three";
import { Link } from "./Link";

interface Props {
	transform: number[];
}

export function RevoluteJoint({ transform }: Props) {

    const logged = useRef(false);
	const matrix = useMemo(() => {
		const m = new THREE.Matrix4();
		m.fromArray(transform);
		m.transpose();
		// m.set(
		//     transform[0], transform[1], transform[2], transform[3],
		//     transform[4], transform[5], transform[6], transform[7],
		//     transform[8], transform[9], transform[10], transform[11],
		//     transform[12], transform[13], transform[14], transform[15],
		// );
		// console.log(m)
		//

		return m;
	}, [transform])

	if (!logged.current) {
        logged.current = true;

        const origin = new THREE.Vector3();
        origin.setFromMatrixPosition(matrix);

        console.log("cylinder at:", origin.toArray());
    }

	return (
		<>
			<group matrix={matrix} matrixAutoUpdate={false}>
				<mesh rotation={[Math.PI / 2, 0, 0]} >
					<axesHelper args={[50]}/>
				</mesh>
				{/*<mesh rotation={[Math.PI / 2, 0, 0]} >*/}
				{/*<mesh >
					<cylinderGeometry args={[10, 10, 20, 32]}/>
					<meshStandardMaterial color="red" />
				</mesh>*/}

			</group>

		</>
	)
}
