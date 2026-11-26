import * as THREE from "three"

export function Link({ a, b }) {
    const start = new THREE.Vector3(...a);
    const end = new THREE.Vector3(...b);

    const direction = new THREE.Vector3()
        .subVectors(end, start);

    const length = direction.length();

    const midpoint = new THREE.Vector3()
        .addVectors(start, end)
        .multiplyScalar(0.5);

    const quaternion = new THREE.Quaternion();

    quaternion.setFromUnitVectors(
        new THREE.Vector3(0, 0, 1),
        direction.clone().normalize()
    );

    return (
        <mesh
            position={midpoint}
            quaternion={quaternion}
        >
            <boxGeometry args={[10, 10, length]} />
            <meshStandardMaterial color="orange" />
        </mesh>
    );
}
