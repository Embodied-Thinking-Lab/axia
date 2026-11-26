import { RevoluteJoint } from "./RevoluteJoint"
import { Link } from "./Link";
import { useRef } from "react";

export function DHViewer({ jointTransforms, positions}) {
	const logged = useRef(false);
	const identity = [
	    1,0,0,0,
	    0,1,0,0,
	    0,0,1,0,
	    0,0,0,1
	];

	if (!logged.current) {
		logged.current = true;

		jointTransforms.forEach((m, i) => {
		    console.log(
		        "joint",
		        i,
		        "translation",
		        [m[3], m[7], m[11]]
		    );
		});

	}

	return (
		<group>
			{jointTransforms.map((matrix, i) => (
				<RevoluteJoint
			        key={i}
			        transform={matrix}
			    />
			))}

			{positions.slice(0, -1).map((_, i) => (
			    <Link
			        key={i}
			        a={[
			            positions[i].x,
			            positions[i].y,
			            positions[i].z
			        ]}
			        b={[
			            positions[i + 1].x,
			            positions[i + 1].y,
			            positions[i + 1].z
			        ]}
			    />
			))}
			<mesh position={[
				positions[7].x,
				positions[7].y,
				positions[7].z,
			]}>
				<sphereGeometry args={[10, 10, 20]}/>
				<meshStandardMaterial color="red" />
			</mesh>
		</group>
	)
}
