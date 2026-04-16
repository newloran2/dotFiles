local mapper = import 'buttonMapper.libsonnet';
{
  device(is_keyboard, is_pointing_device, product_id, vendor_id, ignore_vendor_events, maps): {
    identifiers: {
      is_keyboard: is_keyboard,
      is_pointing_device: is_pointing_device,
      product_id: product_id,
      vendor_id: vendor_id,
    },
    ignore_vendor_events: ignore_vendor_events,
    ignore: false,

    simple_modifications: [
      {
        from: mapper.map(item[0]),

        to: [
          mapper.map(item[1]),
        ],
      }
      for item in maps
    ],
  },

  keychron:
    self.device(
      true,
      false,
      53296,
      13364,
      false,
      []
    ),
    naga_mouse:
      self.device(
        false,
        true,
        180,
        5426,
        false,
        [
          ['1', 'button4'],
          ['2', 'button5'],
          ['3', 'button6'],
          ['4', 'button7'],
          ['5', 'button8'],
          ['6', 'button9'],
          ['7', 'button10'],
          ['8', 'button11'],
          ['9', 'button12'],
          ['0', 'button13'],
          ['hyphen', 'button14'],
          ['equal_sign', 'button15'],
        ]
      ),
  naga:
    self.device(
      true,
      false,
      180,
      5426,
      false,
      [
        ['1', 'button4'],
        ['2', 'button5'],
        ['3', 'button6'],
        ['4', 'button7'],
        ['5', 'button8'],
        ['6', 'button9'],
        ['7', 'button10'],
        ['8', 'button11'],
        ['9', 'button12'],
        ['0', 'button13'],
        ['hyphen', 'button14'],
        ['equal_sign', 'button15'],
      ]
    ),
  naga_blue:
    self.device(
      true,
      true,
      181,
      1678,
      false,
      [
        ['1', 'button4'],
        ['2', 'button5'],
        ['3', 'button6'],
        ['4', 'button7'],
        ['5', 'button8'],
        ['6', 'button9'],
        ['7', 'button10'],
        ['8', 'button11'],
        ['9', 'button12'],
        ['0', 'button13'],
        ['hyphen', 'button14'],
        ['equal_sign', 'button15'],
      ]
    ),
}
