import { useState } from "react";

interface InputFieldProp {
	styling: string,
	row: number,
	col: number,
	value: number,
	onChange: (row: number, col: number, value: number) => void
}

export function DHInputField({styling, row, col, value, onChange}: InputFieldProp) {
	return (
        <input
        	type="number"
            className={styling}
            value={value}
            onChange={(e) =>
                onChange(row, col, e.currentTarget.valueAsNumber)
            }
        />
	)
}
