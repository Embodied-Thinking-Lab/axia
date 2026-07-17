import { useState, useEffect } from "react";

interface JointSliderProps {
	jointId: number;
	label: string;
	value: number;
	min: number;
	max: number;
	onChange: (jointId: number, angle: number) => void;
}

export function JointSlider({ jointId, label, value, min, max, onChange} : JointSliderProps) {
		
	const [textInput, setTextInput] = useState("0");

	useEffect(() => {
		setTextInput(value.toString());
	}, [value]);

	const handleTextInput = (val: string) => {
		setTextInput(val); 

		if (val === "" || val === "-" || val === "-0") return;

		const num = Number(val);
		if (!isNaN(num) && num >= -180 && num <= 180) {
			onChange(jointId, num);
		}
	};


	return (
		<div className="slider-container flex items-center gap-2">
			<label className="block text-sm font-medium text-heading">{label}</label>
			<input 
				type="range"
				min={min}
				max={max} 
				value={value}
				onChange={(e) => onChange(jointId, Number(e.target.value))}
				className="w-100 mr-2 h-2 bg-white rounded-full appearance-none cursor-pointer"
			/>
			<div className="border-gray-50">
				<label>θ:</label> 
				<input 
					className="ml-1 w-[2.5rem]" 
					value={textInput} 
					onChange={(e) => handleTextInput(e.target.value)}
				/>
			</div>
		</div>
	)
}
