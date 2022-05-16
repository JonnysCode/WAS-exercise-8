package tools;

import cartago.*;

public class Converter extends Artifact {

    @OPERATION
    public void convert(double sourceMin, double sourceMax, double targetMin, double targetMax, double value,
            OpFeedbackParam<Double> newValue) {
        double rescaledValue = (value - sourceMin) / (sourceMax - sourceMin);

        rescaledValue *= (targetMax - targetMin);
        rescaledValue += targetMin;

        newValue.set(rescaledValue);
        log("CONVERT: " + value + " was rescaled to " + rescaledValue);
    }
}
