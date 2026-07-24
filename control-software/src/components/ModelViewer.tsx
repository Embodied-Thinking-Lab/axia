import { Canvas } from "@react-three/fiber";
import { OrbitControls, useGLTF } from "@react-three/drei";

function Model() {
    const { scene } = useGLTF("/models/robot_6_axis.glb");

    return <primitive object={scene} />;
}

export default function ModelViewer() {
    return (
        <Canvas
            camera={{
                position: [2, 2, 5],
                fov: 60,
            }}
        >
            <ambientLight intensity={1} />

            <directionalLight
                position={[5, 5, 5]}
                intensity={2}
            />

            <Model />

            <OrbitControls />
        </Canvas>
    );
}
