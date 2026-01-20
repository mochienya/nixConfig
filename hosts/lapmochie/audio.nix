{
  services.pipewire.extraConfig.pipewire = {
    "48-higher-quality-audio" = {
      "context.properties" = {
        "default.clock.rate" = 192000;
        "default.clock.allowed-rates" = [
          44100
          48000
          88200
          96000
          192000
        ];
      };
      "stream.properties"."resample.quality" = 10;
    };
  };
}
