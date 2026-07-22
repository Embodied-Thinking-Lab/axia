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
	const [localValue, setLocalValue] = useState<number>(value);

	useEffect(() => {
		setTextInput(value.toString());
	}, [value]);

	useEffect(() => {
        setLocalValue(value);
    }, [value]);

	const handleRelease = () => {
        onChange(jointId, localValue);
    };

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
				value={localValue}
                onChange={(e) => setLocalValue(parseFloat(e.target.value))}
                onPointerUp={handleRelease}
               
				className="w-100 mr-2 h-2 bg-white rounded-full appearance-none cursor-pointer"
			/>
			<div className="border-gray-50">
				<label>θ:</label> 
				<input 
					className="ml-1 w-[2.5rem] border border-gray-800 rounded-sm px-1" 

					value={textInput} 
					onChange={(e) => handleTextInput(e.target.value)}
				/>
			</div>
		</div>
	)
}
