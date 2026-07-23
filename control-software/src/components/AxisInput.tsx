import { Vector3 } from "../props"
import { useState } from "react";

interface TextInputProp {
	label: string;
  	type: string;
  	value: number;
  	onChange: (axis: keyof Vector3, val: number) => void; 
}

export function AxisInput({ label, type, onChange }: TextInputProp) {
	const [textInput, setTextInput] = useState("0");


	const handleTextInput = (val: string) => {
		setTextInput(val); 

		if (val === "" || val === "-" || val === "-0") return;

		const num = Number(val);
		if (!isNaN(num) && num >= -180 && num <= 180) {
			onChange(type, num);
		}
	};
  	return (
    	<div className="flex gap-1">
			<label>{label}</label>
			<input
				className="w-[2.5rem] border border-gray-800 rounded-sm px-1"
				value={textInput}
				onChange={(e) => handleTextInput(e.target.value)} 
			/>
    	</div>
  	)
}

