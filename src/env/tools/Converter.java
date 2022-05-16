package tools;

import cartago.*;

public class Converter extends Artifact {

    @OPERATION
    public void convert(double sourceMin, double sourceMax, double targetMin, double targetMax, double value,
            OpFeedbackParam<Integer> newValue) {
        double rescaledValue = (value - sourceMin) / (sourceMax - sourceMin);

        rescaledValue *= (targetMax - targetMin);
        rescaledValue += targetMin;

        newValue.set((int) rescaledValue);
        log("CONVERTER: " + value + " was rescaled to " + rescaledValue);
    }
}
