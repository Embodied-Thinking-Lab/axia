import { RevoluteJoint } from "./RevoluteJoint"

export function DHViewer({ dhParams }) {
	return (
		<group>
			{dhParams.map((row: any, i: number) => (
				<RevoluteJoint
					key={i}
					r={row[0]}
					alpha={row[1]}
					d={row[2]}
					theta={row[3]}
				/>
			))
			}
		</group>
	)
}
