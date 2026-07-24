import { RevoluteJoint } from "./RevoluteJoint"

export function DHViewer({linkTransforms}) {
	return (
		<group>

			{linkTransforms.map((matrix, i: number) => (
				<RevoluteJoint key={i} transform={matrix}/>
			))}
		</group>
	)
}
