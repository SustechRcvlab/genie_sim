# Copyright (c) 2023-2025, AgiBot Inc. All Rights Reserved.
# Author: Genie Sim Team
# License: Mozilla Public License Version 2.0

from benchmark.ader.action.common_actions import EvaluateAction, ActionBase, ActionEvent
import numpy as np

from base_utils.logger import Logger

logger = Logger()


class Cover(EvaluateAction):
    def __init__(self, env, active_obj, passive_obj):
        super().__init__(env)
        self.active_obj = active_obj
        self.passive_obj = passive_obj
        self._done_flag = False
        self.threshold = 0.5

    def update(self, delta_time: float) -> float:
        # Get the AABB bounding box of two objects
        aa_A, bb_A = self.get_obj_aabb_new(self.active_obj)
        aa_B, bb_B = self.get_obj_aabb_new(self.passive_obj)

        # Calculate the active center of gravity z and the passive top z
        active_cg = (aa_A[2] + bb_A[2]) / 2
        passive_top = bb_B[2]

        if active_cg - passive_top > 0.002:
            return super().update(delta_time)

        # Calculate projection intersection of X-Y planes
        x_min = max(aa_A[0], aa_B[0])
        x_max = min(bb_A[0], bb_B[0])
        y_min = max(aa_A[1], aa_B[1])
        y_max = min(bb_A[1], bb_B[1])

        # Calculate the effective intersection area
        inter_area = 0.0
        if x_max > x_min and y_max > y_min:
            inter_area = (x_max - x_min) * (y_max - y_min)

        # Calculate the length of three dimensions of active objects
        dx = bb_A[0] - aa_A[0]
        dy = bb_A[1] - aa_A[1]
        dz = bb_A[2] - aa_A[2]

        # Calculate the area of ​​the largest surface as the base area
        area_A = max(
            dx * dy, dx * dz, dy * dz
        )  # Take the largest area of ​​the three faces
        # Calculate the base area of ​​an active object
        dx = bb_B[0] - aa_B[0]
        dy = bb_B[1] - aa_B[1]
        dz = bb_B[2] - aa_B[2]
        area_B = max(dx * dy, dx * dz, dy * dz)
        area = min(area_A, area_B)

        # If the area ratio exceeds the threshold, the mark is completed
        if area > 0 and inter_area / area >= self.threshold:
            self._done_flag = True

        return super().update(delta_time)

    def _is_done(self) -> bool:
        return self._done_flag

    def update_progress(self):
        if self._done_flag:
            self.progress_info["STATUS"] = "SUCCESS"

    def handle_action_event(self, action: ActionBase, event: ActionEvent) -> None:
        logger.info("Action [Cover] evt: %d" % (event.value))

        if event == ActionEvent.STARTED:
            pass
        elif event == ActionEvent.PAUSED:
            pass
        elif event == ActionEvent.CANCELED:
            pass
        elif event == ActionEvent.FINISHED:
            self.progress_info["SCORE"] = 1
