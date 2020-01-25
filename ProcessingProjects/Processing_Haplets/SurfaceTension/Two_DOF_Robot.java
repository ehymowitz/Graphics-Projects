import processing.core.PApplet;

public class Two_DOF_Robot{
	
	private Board  haplyBoard;
	private Device  widget; 
	private Mechanisms pantograph;

	private byte deviceID = 5;
	private int CW = 0;
	private int CCW = 1;
	
	private float angles[] = new float[2];
	private float torques[] = new float[2];
	
	private float position[] = {0, 0};
	private float force[] = {0, 0};
	
	
	public Two_DOF_Robot(PApplet app, String portName){
		
		haplyBoard = new Board(app, portName, 0);
		widget = new Device(deviceID, haplyBoard);
		pantograph = new Pantograph();
		
		widget.set_mechanism(pantograph);
		
		widget.add_actuator(1, CW, 1);
		widget.add_actuator(2, CW, 2);
		
		widget.add_encoder(1, CW, 180, 13824, 1);
		widget.add_encoder(2, CW, 0, 13824, 2);
		
		widget.device_set_parameters();
	}
	
	
	public void read_robot_data(){
		if(haplyBoard.data_available()){
			widget.device_read_data();
			
			angles = widget.get_device_angles();
			position = widget.get_device_position(angles);
			
			for(int i = 0; i < position.length; i++){
				position[i] = position[i] * 200;
			}
		}
	}
	
	
	public void write_robot_data(float xForce, float yForce){
		force[0] = -xForce / 20000;
		force[1] = yForce / 20000;
		
		torques = widget.set_device_torques(force);
		widget.device_write_torques();
	}
	
	
	public float[] get_device_position(){
		return position;
	}		
	
}
