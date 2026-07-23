import { useState } from "react";

interface InputFieldProp {
	styling: string,
	row: number,
	col: number,
	value: number,
	onChange: (row: number, col: number, value: number) => void
}

export function DHInputField({styling, row, col, value, onChange}: InputFieldProp) {
	// const [tempVal, setTempVal] = useState(0);
	// setTempVal(defaultValue);
	
	// const onSubmit = (val: number) => {
	// 	setTempVal(val);
	// 	onChange(row, col, val);
	// }

	return (
		// <input
		// 	className={styling}
		// 	value={tempVal}
		// 	onChange={(e) => onSubmit(e.target.valueAsNumber)}
		// />
		//
        <input
            className={styling}
            value={value}
            onChange={(e) =>
                onChange(row, col, e.currentTarget.valueAsNumber)
            }
        />
	)
}
